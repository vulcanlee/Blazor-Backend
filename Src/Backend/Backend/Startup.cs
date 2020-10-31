using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Backend.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Http.Features;
using System.Diagnostics;
using ShareBusiness.Helpers;
using DataTransferObject.DTOs;
using Newtonsoft.Json;
using Syncfusion.Blazor;
using Microsoft.EntityFrameworkCore;
using DataAccessLayer.Models;
using AutoMapper;
using Backend.Helpers;
using Backend.Services;
using Backend.RazorModels;

namespace Backend
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddRazorPages();
            services.AddServerSideBlazor();
            services.AddSingleton<WeatherForecastService>();

            #region Syncfusion 元件
            services.AddSyncfusionBlazor();
            #endregion

            #region EF Core
            string foo = Configuration.GetConnectionString(MagicHelper.DefaultConnectionString);
            services.AddDbContext<SchoolContext>(options =>
            options.UseSqlServer(Configuration.GetConnectionString(
                MagicHelper.DefaultConnectionString)), ServiceLifetime.Transient);
            AddOtherServices(services);
            services.AddAutoMapper(c => c.AddProfile<AutoMapping>(), typeof(Startup));
            #endregion

            #region 加入使用 Cookie 認證需要的宣告
            services.Configure<CookiePolicyOptions>(options =>
            {
                options.CheckConsentNeeded = context => true;
                options.MinimumSameSitePolicy = Microsoft.AspNetCore.Http.SameSiteMode.None;
            });
            services.AddAuthentication(
                CookieAuthenticationDefaults.AuthenticationScheme)
                .AddCookie()
                .AddJwtBearer(JwtBearerDefaults.AuthenticationScheme, options =>
                {
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuer = true,
                        ValidateAudience = true,
                        ValidateLifetime = true,
                        ValidateIssuerSigningKey = true,
                        ValidIssuer = Configuration["Tokens:ValidIssuer"],
                        ValidAudience = Configuration["Tokens:ValidAudience"],
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration["Tokens:IssuerSigningKey"])),
                        RequireExpirationTime = true,
                        ClockSkew = TimeSpan.Zero,
                    };
                    options.Events = new JwtBearerEvents()
                    {
                        OnAuthenticationFailed =  async context =>
                        {
                            ////context.NoResult();

                            context.Response.StatusCode = 401;
                            context.Response.HttpContext.Features.Get<IHttpResponseFeature>().ReasonPhrase = context.Exception.Message;
                            APIResult apiResult = JWTTokenFailHelper.GetFailResult(context.Exception);

                            context.Response.ContentType = "application/json";
                            await context.Response.WriteAsync(JsonConvert.SerializeObject(apiResult));
                            return ;
                        },
                        OnChallenge = async context =>
                        {
                            context.HandleResponse();
                            return ;
                        },
                        OnTokenValidated = context =>
                        {
                            Console.WriteLine("OnTokenValidated: " +
                                context.SecurityToken);
                            return Task.CompletedTask;
                        }

                    };
                });
            //JwtBearerDefaults.AuthenticationScheme
            #endregion

            #region 新增控制器和 API 相關功能的支援，但不會加入 views 或 pages
            services.AddControllers();
            #endregion

            #region 修正 Web API 的 JSON 處理
            services.AddControllers().AddJsonOptions(config =>
            {
                config.JsonSerializerOptions.PropertyNamingPolicy = null;
            });
            #endregion
        }

        private static void AddOtherServices(IServiceCollection services)
        {
            #region 註冊服務
            services.AddTransient<IProductService, ProductService>();
            #endregion

            #region 註冊 Razor Model
            services.AddTransient<ProductRazorModel>();
            #endregion

            #region 其他服務註冊
            #endregion
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            #region Syncfusion License Registration
            Syncfusion.Licensing.SyncfusionLicenseProvider.RegisterLicense("License Key");
            #endregion

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();

            #region 指定要使用 Cookie & 使用者認證的中介軟體
            app.UseCookiePolicy();
            app.UseAuthentication();
            #endregion

            #region 指定使用授權檢查的中介軟體
            app.UseAuthorization();
            #endregion

            app.UseEndpoints(endpoints =>
            {
                #region Adds endpoints for controller actions to the IEndpointRouteBuilder without specifying any routes.
                endpoints.MapControllers();
                #endregion

                endpoints.MapBlazorHub();
                endpoints.MapFallbackToPage("/_Host");
            });
        }
    }
}
