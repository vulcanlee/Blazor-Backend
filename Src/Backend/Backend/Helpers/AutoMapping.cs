﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Helpers
{
    using AutoMapper;
    using DataAccessLayer.Models;
    using Backend.AdapterModels;

    public class AutoMapping : Profile
    {
        public AutoMapping()
        {
            CreateMap<Holuser, HoluserAdapterModel>();
            CreateMap<HoluserAdapterModel, Holuser>();
            CreateMap<Product, ProductAdapterModel>();
            CreateMap<ProductAdapterModel, Product>();
            CreateMap<Order, OrderAdapterModel>();
            CreateMap<OrderAdapterModel, Order>();
            CreateMap<OrderItem, OrderItemAdapterModel>();
            CreateMap<OrderItemAdapterModel, OrderItem>();
        }
    }
}
