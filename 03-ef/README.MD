# Entity Framework
#### 21/02/2020 godz: 11:15 - 12:45
#### Author: Uladzislau Tumilovich

## Sprawozsanie

**1 Code First**

Stworzyłem projekt lTumilovichProductEF i dodałem klasę Product z polami int ProductID, string Name, int UnitsInStock

**Product class**
``` yaml
namespace lTumilovichProductEF
{
    class Product
    {
        public int ProductID { get; set; }
        public string Name { get; set; }
        public int UnitsInStock { get; set; }
    }
}
```

Dalej stworzyłem klasę ProdContext dziedziczącą po DbContext.

**ProdContext class**
``` yaml
namespace lTumilovichProductEF
{
    class ProdContext:DbContext
    {
        public DbSet<Product> Products { set; get; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) =>
            optionsBuilder.UseSqlite("DataSource=Product.db");
    }
}
```

Następnie w metodzie Main clasy Program napisałem kod uruchomiący bazę

**Program class**
``` yaml
namespace lTumilovichProductEF
{
    class Program
    {
        private static void AddProduct(ProdContext prodContext)
        {
            Console.WriteLine("Input name of product:");
            String prodName = Console.ReadLine();

            Product product = new Product();
            product.Name = prodName;

            prodContext.Products.Add(product);
            prodContext.SaveChanges();
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

        static void Main(string[] args)
        {
            ProdContext prodContext = new ProdContext();
            
            AddProduct(prodContext);
            PrintProductsNames(prodContext);
        }
    }
}
```

Wynik działania programu

![result](result1.jpg)

Wygląd tabeli Products

![baza](products_sql1.jpg)

**2**

W drugim punkcie zmodyfikowałem kod z pierszego punktu dodaniem clasy Supplier

**Supplier class**
``` yaml
namespace lTumilovichProductEF
{
    class Supplier
    {
        public int SupplierID { get; set; }
        public String CompanyName { get; set; }
        public String Street { get; set; }
        public String City { get; set; }
    }
}
```

Zmodyfikowałem klasę Product dodaniem klucza obcego Supplier

**Product class**
``` yaml
namespace lTumilovichProductEF
{
    class Product
    {
        public int ProductID { get; set; }
        public string Name { get; set; }
        public int UnitsInStock { get; set; }
        public Supplier Supplier { get; set; }
    }
}
```

W klasie ProdContext dodałem set Suppliers

**ProdContext class**
``` yaml
namespace lTumilovichProductEF
{
    class ProdContext:DbContext
    {
        public DbSet<Product> Products { set; get; }
        public DbSet<Supplier> Suppliers { set; get; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) =>
            optionsBuilder.UseSqlite("DataSource=Product.db");
    }
}
```

I na koniec zmodyfikowałem metodę Main klasy Program

**Program class**
```` yaml
namespace lTumilovichProductEF
{
    class Program
    {
        private static void AddProduct(ProdContext prodContext)
        {
            Console.WriteLine("Input name of product:");
            String prodName = Console.ReadLine();

            Product product = new Product();
            product.Name = prodName;

            prodContext.Products.Add(product);
            prodContext.SaveChanges();
        }

        private static void AddSupplier(ProdContext prodContext)
        {
            Console.WriteLine("Input company name of supplier:");
            String companyName = Console.ReadLine();

            Supplier supplier = new Supplier();
            supplier.CompanyName = companyName;

            prodContext.Suppliers.Add(supplier);
            prodContext.SaveChanges();
        }

        private static void ConnectProductSupplier(ProdContext prodContext)
        {
            Console.WriteLine("Input name of product");
            String prodName = Console.ReadLine();
            Product product = prodContext.Products.Where(p => p.Name == prodName).FirstOrDefault();

            Console.WriteLine("Input company name of supplier:");
            String companyName = Console.ReadLine();
            Supplier supplier = prodContext.Suppliers.Where(s => s.CompanyName == companyName).FirstOrDefault();

            product.Supplier = supplier;
            prodContext.SaveChanges();         
        }

        public static void PrintProductsWithSuppliers(ProdContext prodContext)
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
            var query = from s in prodContext.Suppliers
                        select s.CompanyName;

            foreach (var item in query)
            {
                Console.WriteLine(item);
            }
        }

        static void Main(string[] args)
        {
            ProdContext prodContext = new ProdContext();
            
            AddProduct(prodContext);
            PrintProductsNames(prodContext);

            AddSupplier(prodContext);
            PrintSuppliersCompaniesNames(prodContext);

            PrintProductsWithSuppliers(prodContext);

            ConnectProductSupplier(prodContext);

            PrintProductsWithSuppliers(prodContext);
        }
    }
}
````

Wynik działania programu

![result](result2.jpg)

Wygląd tabeli Products

![baza](products_sql2.jpg)

Wygląd tabeli Suppliers

![baza](suppliers_sql2.jpg)
