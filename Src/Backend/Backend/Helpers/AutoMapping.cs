using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Helpers
{
    using AutoMapper;
    using DataAccessLayer.Models;
    using Backend.AdapterModels;
    using DataTransferObject.DTOs;

    public class AutoMapping : Profile
    {
        public AutoMapping()
        {
            #region Blazor AdapterModel
            CreateMap<Holuser, HoluserAdapterModel>();
            CreateMap<HoluserAdapterModel, Holuser>();
            CreateMap<Product, ProductAdapterModel>();
            CreateMap<ProductAdapterModel, Product>();
            CreateMap<Order, OrderAdapterModel>();
            CreateMap<OrderAdapterModel, Order>();
            CreateMap<OrderItem, OrderItemAdapterModel>();
            CreateMap<OrderItemAdapterModel, OrderItem>();
            #endregion

            #region DTO
            CreateMap<Holuser, HoluserDto>();
            CreateMap<HoluserDto, Holuser>();
            CreateMap<Product, ProductDto>();
            CreateMap<ProductDto, Product>();
            #endregion
        }
    }
}
