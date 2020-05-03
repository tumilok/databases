# Entity Framework
#### Author: Uladzislau Tumilovich

## Sprawozsanie

**1 Code First**

Stworzyłem projekt lTumilovichProductEF i dodałem klasę Product z polami int ProductID, string Name, int UnitsInStock

**Product class**
``` yaml
class Product
{
    public int ProductID { get; set; }
    public string Name { get; set; }
    public int UnitsInStock { get; set; }
}
```

Dalej stworzyłem klasę ProdContext dziedziczącą po DbContext.

**ProdContext class**
``` yaml
class ProdContext:DbContext
{
    public DbSet<Product> Products { set; get; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) =>
        optionsBuilder.UseSqlite("DataSource=Product.db");
}
```

Następnie w klasie Program dodałem metodę AddProduct, która dodaje produkt do bazy i metodę PrintProductNames, która wyświetla nazwy produktów z bazy. Na koniec wyzywam tę metody w metodzie Main.

**Program class**
``` yaml
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
```

Wynik działania programu

![result](result1.jpg)

Wygląd tabeli Products

![table](products_table1.jpg)

Select z tabeli Product

![select](products_sql1.jpg)

**2**

W drugim punkcie zmodyfikowałem kod z pierwszego punktu dodaniem klasy Supplier

**Supplier class**
``` yaml
class Supplier
{
    public int SupplierID { get; set; }
    public String CompanyName { get; set; }
    public String Street { get; set; }
    public String City { get; set; }
}
```

Zmodyfikowałem klasę Product dodaniem klucza obcego Supplier

**Product class**
``` yaml
class Product
{
    public int ProductID { get; set; }
    public string Name { get; set; }
    public int UnitsInStock { get; set; }
    public Supplier Supplier { get; set; }
}
```

W klasie ProdContext dodałem set Supplierów

**ProdContext class**
``` yaml
class ProdContext:DbContext
{
    public DbSet<Product> Products { set; get; }
    public DbSet<Supplier> Suppliers { set; get; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) =>
        optionsBuilder.UseSqlite("DataSource=Product.db");
}
```

Na koniec dodałem metody AddSupplier, PrintSuppliersCompaniesNames,  ConnectProductSupplier, PrintProductsWithSuppliers i zmodyfikowałem metodę Main klasy Program

**Program class**
```` yaml
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
````

Wynik działania programu

![result](result2.jpg)

Wygląd tabeli Products

![table](products_table2.jpg)

Wygląd tabeli Suppliers

![table](suppliers_table2.jpg)

Select z tabeli Product

![select](products_sql2.jpg)

Select z tabeli Suppliers

![select](suppliers_sql2.jpg)

**3**

W trzecim punkcie odwróciłem relacje tabel Product i Suppliers przez usunięcie pola Supplier z klasy Products i dodaniem listy Produktów w klasie Suppliers

**Product class**
``` yaml
class Product
{
    public int ProductID { get; set; }
    public string Name { get; set; }
    public int UnitsInStock { get; set; }
}
```

**Supplier class**
``` yaml
class Supplier
{
    public Supplier()
    {
        Products = new List<Product>();
    }

    public int SupplierID { get; set; }
    public String CompanyName { get; set; }
    public String Street { get; set; }
    public String City { get; set; }
    public List<Product> Products { get; set; }
}
```

Na koniec dodałem do klasy Program metodę PrintSuppliersWithProducts oraz zmodyfikowałem metody ConnectProductSupplier i Main.

**Program class**
``` yaml
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

        supplier.Products.Add(product);
        prodContext.SaveChanges();         
    }

    public static void PrintSuppliersWithProducts(ProdContext prodContext)
    {
        Console.WriteLine("List of suppliers with products from database:");

        var data = prodContext.Suppliers.Include(s => s.Products).ToList();
        foreach (var s in data)
        {
            Console.WriteLine("Supplier: " + s.CompanyName);
            foreach (var p in s.Products)
            {
                Console.WriteLine(p.Name);
            }
        }
    }

    static void Main(string[] args)
    {
        ProdContext prodContext = new ProdContext();

        AddProduct(prodContext);
        AddSupplier(prodContext);

        ConnectProductSupplier(prodContext);

        PrintSuppliersWithProducts(prodContext);
    }
}
```

Wynik działania programu

![result](result3.jpg)

Wygląd tabeli Products

![table](products_table3.jpg)

Wygląd tabeli Suppliers

![table](suppliers_table3.jpg)

Select z tabeli Product

![select](products_sql3.jpg)

Select z tabeli Suppliers

![select](suppliers_sql3.jpg)


**4**

W czwartym punkcie dla otrzymania relacji dwustronnej dodałem pole Supplier w klasie Product

**Product class**
``` yaml
class Product
{
    public int ProductID { get; set; }
    public string Name { get; set; }
    public int UnitsInStock { get; set; }
    public Supplier Supplier { get; set; }
}
```

Następnie zmodyfikowałem klasę Program dla wizualizacji programu

**Program class**
``` yaml
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

        supplier.Products.Add(product);
        product.Supplier = supplier;
        prodContext.SaveChanges();         
    }

    public static void PrintSuppliersWithProducts(ProdContext prodContext)
    {
        Console.WriteLine("List of suppliers with products from database:");

        var data = prodContext.Suppliers.Include(s => s.Products).ToList();
        foreach (var s in data)
        {
            Console.WriteLine("Supplier: " + s.CompanyName);
            foreach (var p in s.Products)
            {
                Console.WriteLine(p.Name);
            }
        }
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

    static void Main(string[] args)
    {
        ProdContext prodContext = new ProdContext();

        AddProduct(prodContext);
        AddSupplier(prodContext);

        ConnectProductSupplier(prodContext);

        PrintSuppliersWithProducts(prodContext);
        PrintProductsWithSuppliers(prodContext);
    }
}
```

Wynik działania programu

![result](result4.jpg)

Wygląd tabeli Products

![table](products_table4.jpg)

Wygląd tabeli Suppliers

![table](suppliers_table4.jpg)

Select z tabeli Product

![select](products_sql4.jpg)

Select z tabeli Suppliers

![select](suppliers_sql4.jpg)
