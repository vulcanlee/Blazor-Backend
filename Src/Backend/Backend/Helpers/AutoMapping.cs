using System;
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
            CreateMap<Product, ProductAdapterModel>();
            CreateMap<ProductAdapterModel, Product>();
        }
    }
}
