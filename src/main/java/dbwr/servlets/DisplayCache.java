/*******************************************************************************
 * Copyright (c) 2019 Oak Ridge National Laboratory.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the LICENSE
 * which accompanies this distribution
 ******************************************************************************/
package dbwr.servlets;

import java.lang.ref.SoftReference;
import java.util.Collection;
import java.util.concurrent.ConcurrentHashMap;

/** Cached display html content
 *  @author Kay Kasemir
 */
public class DisplayCache
{
	private static final ConcurrentHashMap<DisplayKey, SoftReference<CachedDisplay>> cache = new ConcurrentHashMap<>();

	@FunctionalInterface
	public interface DisplayCreator
	{
	    public CachedDisplay create(final DisplayKey key) throws Error;
	}

	public static CachedDisplay getOrCreate(final DisplayKey key, final DisplayCreator creator)
	{
	    final SoftReference<CachedDisplay> ref = cache.computeIfAbsent(key, k -> new SoftReference<>(creator.create(k)));
	    CachedDisplay cached = ref.get();
        if (cached == null)
        {   // Expired
            cached = creator.create(key);
            cache.put(key, new SoftReference<>(cached));
        }
        else
        {
            System.err.println("CACHED: " + cached);
            cached.registerCall();
        }
        return cached;
	}

	public static Collection<SoftReference<CachedDisplay>> getEntries()
	{
	    return cache.values();
	}
}