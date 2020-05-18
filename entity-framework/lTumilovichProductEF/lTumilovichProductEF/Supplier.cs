using System;
using System.Collections.Generic;
using System.Text;

namespace lTumilovichProductEF
{
    class Supplier:Company
    {
        public Supplier()
        {
            Products = new List<Product>();
        }

        public string BankAccountNumber { get; set; }
        public List<Product> Products { get; set; }
    }
}
