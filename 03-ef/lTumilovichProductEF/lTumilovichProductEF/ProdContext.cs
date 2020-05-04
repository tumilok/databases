using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Sqlite;

namespace lTumilovichProductEF
{
    class ProdContext:DbContext
    {
        public DbSet<Product> Products { set; get; }
        public DbSet<Company> Companies { set; get; }
        public DbSet<Category> Categories { set; get; }
        public DbSet<Invoice> Invoices { set; get; }
        public DbSet<InvoiceProduct> InvoiceProducts { set; get; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) =>
            optionsBuilder.UseSqlite("DataSource=Product.db");

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<InvoiceProduct>().HasKey(ip => new { ip.ProductID, ip.InvoiceID });
            modelBuilder.Entity<Customer>();
            modelBuilder.Entity<Supplier>();
        }
    }
}
