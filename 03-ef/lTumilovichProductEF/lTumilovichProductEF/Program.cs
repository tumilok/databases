using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;

namespace lTumilovichProductEF
{
    class Program
    {
        private static void AddProduct(ProdContext prodContext, string prodName)
        {
            Product product = new Product();
            product.Name = prodName;

            prodContext.Products.Add(product);
            prodContext.SaveChanges();
        }

        private static void AddSupplier(ProdContext prodContext, string companyName,
            string street, string city, string zipCode, string bankAccountNumber)
        {
            Supplier supplier = new Supplier
            {
                CompanyName = companyName,
                Street = street,
                City = city,
                ZipCode = zipCode,
                BankAccountNumber = bankAccountNumber
            };
            prodContext.Companies.Add(supplier);
            prodContext.SaveChanges();
        }

        private static void AddCustomer(ProdContext prodContext, string companyName,
            string street, string city, string zipCode, float discount)
        {
            Customer customer = new Customer
            {
                CompanyName = companyName,
                Street = street,
                City = city,
                ZipCode = zipCode,
                Discount = discount
            };
            prodContext.Companies.Add(customer);
            prodContext.SaveChanges();
        }

        private static void AddCategory(ProdContext prodContext, string categoryName)
        {
            Category category = new Category();
            category.Name = categoryName;

            prodContext.Categories.Add(category);
            prodContext.SaveChanges();
        }

        private static void AddInvoice(ProdContext prodContext, int invoiceNumber, int invoiceQuantity)
        {
            Invoice invoice = new Invoice();
            invoice.InvoiceNumber = invoiceNumber;
            invoice.Quantity = invoiceQuantity;

            prodContext.Invoices.Add(invoice);
            prodContext.SaveChanges();
        }

        private static void AddInvoiceProduct(ProdContext prodContext, int invoiceNumber, string prodName)
        {
            Invoice invoice = prodContext.Invoices.Where(i => i.InvoiceNumber == invoiceNumber).FirstOrDefault();
            Product product = prodContext.Products.Where(p => p.Name == prodName).FirstOrDefault();

            InvoiceProduct invoiceProduct = new InvoiceProduct();
            invoiceProduct.Invoice = invoice;
            invoiceProduct.Product = product;

            invoice.InvoiceProducts.Add(invoiceProduct);
            product.InvoiceProducts.Add(invoiceProduct);

            prodContext.InvoiceProducts.Add(invoiceProduct);
            prodContext.SaveChanges();
        }

        private static void ConnectProductSupplier(ProdContext prodContext, string prodName, string companyName)
        {
            Product product = prodContext.Products.Where(p => p.Name == prodName).FirstOrDefault();
            Supplier supplier = prodContext.Companies.OfType<Supplier>().Where(s => s.CompanyName == companyName).FirstOrDefault();

            supplier.Products.Add(product);
            product.Supplier = supplier;
            prodContext.SaveChanges();         
        }

        private static void ConnectProductCategory(ProdContext prodContext, string prodName, string categoryName)
        {
            Product product = prodContext.Products.Where(p => p.Name == prodName).FirstOrDefault();
            Category category = prodContext.Categories.Where(c => c.Name == categoryName).FirstOrDefault();

            category.Products.Add(product);
            product.Category = category;
            prodContext.SaveChanges();
        }

        private static void PrintSuppliersWithProducts(ProdContext prodContext)
        {
            Console.WriteLine("List of suppliers with products from database:");

            var data = prodContext.Companies.OfType<Supplier>().Include(s => s.Products).ToList();
            foreach (var s in data)
            {
                Console.WriteLine("Supplier: " + s.CompanyName);
                foreach (var p in s.Products)
                {
                    Console.WriteLine(p.Name);
                }
            }
        }

        private static void PrintProductsWithSuppliers(ProdContext prodContext)
        {
            Console.WriteLine("List of products with suppliers from database:");

            foreach (Product item in prodContext.Products)
            {
                prodContext.Entry(item).Reference(prod => prod.Supplier).Load();

                if (item.Supplier != null)
                {
                    Console.WriteLine(item.Name + " " + item.Supplier.CompanyName);
                }
                else
                {
                    Console.WriteLine(item.Name);
                }
            }
        }

        private static void PrintCategoriesWithProducts(ProdContext prodContext)
        {
            Console.WriteLine("List of categories with products from database:");

            var data = prodContext.Categories.Include(c => c.Products).ToList();
            foreach (var c in data)
            {
                Console.WriteLine("Category: " + c.Name);
                foreach (var p in c.Products)
                {
                    Console.WriteLine("Product: " + p.Name);
                }
            }
        }

        private static void PrintProductsWithCategories(ProdContext prodContext)
        {
            Console.WriteLine("List of products with categories from database:");

            foreach (Product item in prodContext.Products)
            {
                prodContext.Entry(item).Reference(prod => prod.Category).Load();

                if (item.Category != null)
                {
                    Console.WriteLine("Product: " + item.Name + " Category: " + item.Category.Name);
                }
                else
                {
                    Console.WriteLine("Product: " + item.Name);
                }
            }
        }

        private static void PrintProductsOfInvoice(ProdContext prodContext, int invoiceNumber)
        {
            Console.WriteLine("List of products of invoice: " + invoiceNumber);

            var products = prodContext.InvoiceProducts
                .Include(ip => ip.Product)
                .Where(ip => ip.Invoice.InvoiceNumber == invoiceNumber)
                .Select(ip => ip.Product.Name).ToList();

            foreach (var p in products)
            {
                Console.WriteLine(p);
            }
        }

        private static void PrintInvoicesOfProduct(ProdContext prodContext, string prodName)
        {
            Console.WriteLine("List of invoices of product: " + prodName);

            var invoices = prodContext.InvoiceProducts
                .Include(ip => ip.Invoice)
                .Where(ip => ip.Product.Name == prodName)
                .Select(ip => ip.Invoice.InvoiceNumber).ToList();

            foreach (var i in invoices)
            {
                Console.WriteLine(i);
            }
        }

        private static void PrintProductsNames(ProdContext prodContext)
        {
            Console.WriteLine("List of products names from database:");
            var query = from p in prodContext.Products
                        select p.Name;

            foreach (var item in query)
            {
                Console.WriteLine(item);
            }
        }

        private static void PrintSuppliersCompaniesNames(ProdContext prodContext)
        {
            Console.WriteLine("List of suppliers companies names from database:");
            var query = prodContext.Companies.OfType<Supplier>().ToList();

            foreach (var item in query)
            {
                Console.WriteLine("Company Name: " + item.CompanyName + " Bank Account Number: " + item.BankAccountNumber);
            }
        }

        private static void PrintCustomersCompaniesNames(ProdContext prodContext)
        {
            Console.WriteLine("List of customers companies names from database:");
            var query = prodContext.Companies.OfType<Customer>().ToList();

            foreach (var item in query)
            {
                Console.WriteLine("Company Name: " + item.CompanyName + " Discount: " + item.Discount);
            }
        }

        static void Main(string[] args)
        {
            ProdContext prodContext = new ProdContext();

            AddSupplier(prodContext, "Supplier1", "Somewhere", "Anywhere", "12345", "1234567890");
            AddSupplier(prodContext, "Supplier2", "Somewhere", "Anywhere", "12345", "2345678901");
            AddSupplier(prodContext, "Supplier3", "Somewhere", "Anywhere", "12345", "3456789012");
            AddSupplier(prodContext, "Supplier4", "Somewhere", "Anywhere", "12345", "4567890123");
            AddSupplier(prodContext, "Supplier5", "Somewhere", "Anywhere", "12345", "5678901234");
            AddSupplier(prodContext, "Supplier6", "Somewhere", "Anywhere", "12345", "6789012345");
            AddSupplier(prodContext, "Supplier7", "Somewhere", "Anywhere", "12345", "7890123456");

            AddCustomer(prodContext, "Customer1", "Somewhere", "Anywhere", "12345", 0.05f);
            AddCustomer(prodContext, "Customer2", "Somewhere", "Anywhere", "12345", 0.10f);
            AddCustomer(prodContext, "Customer3", "Somewhere", "Anywhere", "12345", 0.15f);
            AddCustomer(prodContext, "Customer4", "Somewhere", "Anywhere", "12345", 0.20f);
            AddCustomer(prodContext, "Customer5", "Somewhere", "Anywhere", "12345", 0.25f);
            AddCustomer(prodContext, "Customer6", "Somewhere", "Anywhere", "12345", 0.35f);
            AddCustomer(prodContext, "Customer7", "Somewhere", "Anywhere", "12345", 0.45f);

            PrintSuppliersCompaniesNames(prodContext);
            PrintCustomersCompaniesNames(prodContext);
        }
    }
}
