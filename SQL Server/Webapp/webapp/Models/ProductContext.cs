using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.VisualStudio.Web.CodeGeneration.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace az203_core.Models
{
    public class ProductContext : DbContext
    {
        // Replace the database connection string  here
        
        public DbSet<Product> Products { get; set; }
        public string connstring;
        protected override void OnConfiguring(DbContextOptionsBuilder options)
        {        
            options.UseSqlServer(connstring);
            base.OnConfiguring(options);
        }

        

    }
}
