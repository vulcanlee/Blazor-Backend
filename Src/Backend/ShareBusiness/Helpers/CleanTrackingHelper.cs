﻿using System;
using System.Collections.Generic;
using System.Text;

namespace ShareBusiness.Helpers
{
    using DataAccessLayer.Models;
    using Microsoft.EntityFrameworkCore;
    public class CleanTrackingHelper
    {
        public static void Clean<T>(SchoolContext context) where T : class
        {
            foreach (var fooXItem in context.Set<T>().Local)
            {
                context.Entry(fooXItem).State = EntityState.Detached;
            }
        }
    }
}
