using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using Backend.Services;
using DataAccessLayer.Models;
using DataTransferObject.DTOs;
using DataTransferObject.Enums;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using ShareBusiness.Factories;

namespace Backend.Controllers
{
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme, Roles = "Administrator")]
    [Produces("application/json")]
    [Route("api/[controller]")]
    [ApiController]
    public class HoluserController : ControllerBase
    {
        private readonly IHoluserService holuserService;
        private readonly IMapper mapper;

        #region 建構式
        public HoluserController(IHoluserService holuserService,
            IMapper mapper)
        {
            this.holuserService = holuserService;
            this.mapper = mapper;
        }
        #endregion

        #region C 新增
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] HolusertDTO holusert)
        {
            APIResult apiResult;
            Holuser record = mapper.Map<Holuser>(holusert);
            if (record != null)
            {
                var isSuccessful = await holuserService.AddAsync(record);
                if (isSuccessful)
                {
                    apiResult = APIResultFactory.Build(true, StatusCodes.Status200OK,
                        ErrorMessageEnum.None, payload: record);
                }
                else
                {
                    apiResult = APIResultFactory.Build(false, StatusCodes.Status200OK,
                        ErrorMessageEnum.無法新增紀錄, payload: record);
                }
            }
            else
            {
                apiResult = APIResultFactory.Build(false, StatusCodes.Status200OK,
                    ErrorMessageEnum.傳送過來的資料有問題, payload: record);
            }
            return Ok(apiResult);
        }
        #endregion

        #region R 查詢
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            APIResult apiResult;
            var allUsers = await (await holuserService.GetAsync()).ToListAsync();
            apiResult = APIResultFactory.Build(true, StatusCodes.Status200OK,
                ErrorMessageEnum.None, payload: allUsers);
            return Ok(apiResult);
        }
      
        [HttpGet("{id}")]
        public async Task<IActionResult> Get([FromRoute] int id)
        {
            APIResult apiResult;
            var user = await holuserService.GetAsync(id);
            if (user != null)
            {
                apiResult = APIResultFactory.Build(true, StatusCodes.Status200OK,
                    ErrorMessageEnum.None, payload: user);
            }
            else
            {
                apiResult = APIResultFactory.Build(false, StatusCodes.Status200OK,
                    ErrorMessageEnum.沒有任何符合資料存在, payload: user);
            }
            return Ok(apiResult);
        }
        #endregion

        #region U 新增
        [HttpPut("{id}")]
        public async Task<IActionResult> Put([FromRoute] int id, [FromBody] HolusertDTO holusert)
        {
            APIResult apiResult;
            var record = await holuserService.GetAsync(id);
            if (record != null)
            {
                Holuser recordTarget = mapper.Map<Holuser>(holusert);
                recordTarget.HoluserId = id;
                var isSuccessful = await holuserService.UpdateAsync(recordTarget);
                if (isSuccessful)
                {
                    apiResult = APIResultFactory.Build(true, StatusCodes.Status200OK,
                        ErrorMessageEnum.None, payload: recordTarget);
                }
                else
                {
                    apiResult = APIResultFactory.Build(false, StatusCodes.Status200OK,
                        ErrorMessageEnum.無法修改紀錄, payload: record);
                }
            }
            else
            {
                apiResult = APIResultFactory.Build(false, StatusCodes.Status200OK,
                    ErrorMessageEnum.沒有任何符合資料存在, payload: record);
            }
            return Ok(apiResult);
        }
        #endregion

        #region D 新增
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            APIResult apiResult;
            var record = await holuserService.GetAsync(id);
            if (record != null)
            {
                var isSuccessful = await holuserService.DeleteAsync(record);
                if (isSuccessful)
                {
                    apiResult = APIResultFactory.Build(true, StatusCodes.Status200OK,
                        ErrorMessageEnum.None, payload: record);
                }
                else
                {
                    apiResult = APIResultFactory.Build(false, StatusCodes.Status200OK,
                        ErrorMessageEnum.無法刪除紀錄, payload: record);
                }
            }
            else
            {
                apiResult = APIResultFactory.Build(false, StatusCodes.Status200OK,
                    ErrorMessageEnum.沒有任何符合資料存在, payload: record);
            }
            return Ok(apiResult);
        }
        #endregion

    }
}
