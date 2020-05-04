using System;
using System.Collections.Generic;
using System.Text;

namespace lTumilovichProductEF
{
    class Invoice
    {
        public Invoice()
        {
            InvoiceProducts = new List<InvoiceProduct>();
        }
        public int InvoiceID { get; set; }
        public int InvoiceNumber { get; set; }
        public int Quantity { get; set; }
        public List<InvoiceProduct> InvoiceProducts { get; set; }
    }
}
