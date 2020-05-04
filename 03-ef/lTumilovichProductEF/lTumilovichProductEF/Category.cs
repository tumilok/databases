using System;
using System.Collections.Generic;
using System.Text;

namespace lTumilovichProductEF
{
    class Category
    {
        public Category()
        {
            Products = new List<Product>();
        }
        public int CategoryID { get; set; }
        public string Name { get; set; }
        public List<Product> Products { get; set; }
    }
}
