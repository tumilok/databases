using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace lTumilovichProductEF
{
    class Product
    {
        public Product()
        {
            InvoiceProducts = new List<InvoiceProduct>();
        }
        public int ProductID { get; set; }
        public string Name { get; set; }
        public int UnitsInStock { get; set; }
        public Supplier Supplier { get; set; }
        public Category Category { get; set; }
        public List<InvoiceProduct> InvoiceProducts { get; set; }
    }
}
