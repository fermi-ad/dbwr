
// Flot plot options
let _db_plot_options =
{
    xaxis:
    {
        mode: "time",
        timeBase: "milliseconds",
        timezone: "browser"
    },
    /*
    zoom:
    {
        interactive: true
    },
    pan:
    {
        interactive: true
    },
    */
    legend:
    {
        show: true,
        position: "nw"
    },
    grid:
    {
        clickable: true
    }    
};

// Information for one trace:
// PV, label, plot data
//
// The last sample, plotobj.data[N], is used for scrolling.
// It carries the same value as plotobj.data[N-1] with a time stamp of 'now'.
// Calls to scroll() update its time stamp.
// When a new value is received from the PV, that scroll sample is removed,
// the actual data is added, and another scroll sample is added back in.
// At the very start, 'null' is added as a scroll sample.
// Flot handles null by creating a gap in the line.
// In update(), there is now a scroll sample that can be removed/replaced,
// no need to handle 'no samples' differently from 'have some samples'.
class DBTrace
{
    /** @param pv Name of PV
     *  @param label Label to use
     *  @param color Color of the trace
     *  @param linewidth Line width
     */
    constructor(pv, label, color, linewidth)
    {
        this.pv = pv;
        
        // Flot plot object with
        // data: [ [ x0, y0 ], [ x1, y1 ], ..., [ xn, yn ] ],
        // starting with null for the 'scroll sample'
        this.plotobj = 
        {
            label: label,
            color: color,   
            clickable: true,
            hoverable: true,
            lines: { lineWidth: linewidth,steps: true },
            data: [ null ]
        };
    }

    /** @param now Time Stamp */
    scroll(now)
    {
        // Replace last sample with one that uses 'now' for time
        let last = this.plotobj.data.pop();
        if (last == null)
            this.plotobj.data.push(null);
        else
            this.plotobj.data.push( [ now, last[1] ]);
    }
    
    /** @param pv Name of PV, might be this one or unknown PV
     *  @param time Time Stamp
     *  @param value Value of that PV
     */
    update(pv, time, value)
    {
        if (pv != this.pv)
            return;
        
        // Add to plot data, see above regarding the duplicate
        // which can be updated in scroll() or update()
        this.plotobj.data.pop();
        this.plotobj.data.push( [ time, value ] );
        this.plotobj.data.push( [ time, value ] );        
    }
}

DisplayBuilderWebRuntime.prototype.widget_init_methods["databrowser"] = widget =>
{
    let i=0, pv = widget.data("pv" + i);
    let traces = [];
    while (pv)
    {
        // console.log("Should connect to PV " + i + ": " + pv);
        dbwr.subscribe(widget, "databrowser", pv);
        
        let color = widget.data("color" + i);
        let linewidth = widget.data("linewidth" + i);
        let label = widget.data("label" + i);
        if (label == undefined)
            label = pv;
        traces.push(new DBTrace(pv, label, color, linewidth));
        
        ++i;
        pv = widget.data("pv" + i);
    }
    widget.data("traces", traces);
    
    __scroll(widget, traces);
    
    let spantext = jQuery("<input>").attr("type", "text");
    spantext.change(event =>
    {
        widget.data("timespan", parseFloat(spantext.val()));
    });    
    
    let checkbox = jQuery("<input>").attr("type", "checkbox");
    checkbox.click(event =>
    {
        widget.data("autospan", checkbox.prop('checked'));
    });
    
    create_contextmenu(widget,
                       [
                           jQuery("<div class=\"Header\">").append("Plot Settings"),
                           jQuery("<label>").append("Time span [sec]: ").append(spantext),
                           jQuery("<label>").append(checkbox).append("&nbsp; Autoscale")                          
                       ]);
  
    widget.on('plotclick', (event, pos, item) =>
    {
        // Update menu UI from widget
        spantext.val(widget.data("timespan"));
        checkbox.prop('checked',
                      widget.data("timespan") <= 0  ||
                      widget.data("autospan"));
        
        toggle_contextmenu(event);
    }); 
};

DisplayBuilderWebRuntime.prototype.widget_update_methods["databrowser"] = function(widget, data)
{
    // console.log("Data Browser " + widget.attr("id") + " update: " + data.pv + " = "  + data.value);

    let time = new Date().getTime();
    let trace, traces = widget.data("traces");
    for (trace of traces)
        trace.update(data.pv, time, data.value);
    __replot(widget, traces);
}

function __scroll(widget, traces)
{
    let time = new Date().getTime();
    let trace;
    for (trace of traces)
        trace.scroll(time);
   
    // Set time axis range
    let sec = widget.data("timespan");
    if (sec <= 0  ||  widget.data("autospan"))
    {   // Autoscale
        _db_plot_options.xaxis.autoScale = "loose"
    }
    else
    {   // Use time span (seconds)
        _db_plot_options.xaxis.autoScale = "none"
        _db_plot_options.xaxis.min = time - sec*1000 
        _db_plot_options.xaxis.max = time 
    }
    
    __replot(widget, traces);
    // Scroll every 3 seconds
    setTimeout(() => __scroll(widget, traces), 3000);
}

function __replot(widget, traces)
{
    let trace, plots = [];
    for (trace of traces)
        plots.push( trace.plotobj );
    jQuery.plot(widget, plots, _db_plot_options);    
}
