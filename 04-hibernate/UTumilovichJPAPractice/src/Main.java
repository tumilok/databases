import org.hibernate.*;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.Query;

import javax.persistence.metamodel.EntityType;

public class Main {
    private static final SessionFactory ourSessionFactory;

    static {
        try {
            Configuration configuration = new Configuration();
            configuration.configure();

            ourSessionFactory = configuration.buildSessionFactory();
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static Session getSession() throws HibernateException {
        return ourSessionFactory.openSession();
    }

    private static void printCategoryProducts(int categoryId) {
        Category category = getSession().get(Category.class, categoryId);
        System.out.println(category.getName() + " product list:");
        for (Product product: category.getProducts()) {
            System.out.println(product.getProductName());
        }
    }

    private static void printProductCategory(int productId) {
        Product product = getSession().get(Product.class, productId);
        System.out.println("Product: " + product.getProductName() + ", Category: " + product.getCategory().getName());
    }

    private static void printInvoiceProducts(int invoiceNumber) {
        Invoice invoice = getSession().get(Invoice.class, invoiceNumber);
        System.out.println("Invoice number:" + invoiceNumber);
        for (Product product: invoice.getProducts()) {
            System.out.println(product.getProductName());
        }
    }

    private static void printProductInvoices(int productId) {
        Product product = getSession().get(Product.class, productId);
        System.out.println("Product: " + product.getProductName());
        for (Invoice invoice: product.getInvoices()) {
            System.out.println(invoice.getInvoiceNumber());
        }
    }

    public static void main(final String[] args) {
        final Session session = getSession();

        Transaction transaction = session.beginTransaction();

        Product newProduct1 = new Product("Milk", 45);
        Product newProduct2 = new Product("Yogurt", 76);
        Product newProduct3 = new Product("Crisps", 34);
        Product newProduct4 = new Product("Bread", 56);
        Product newProduct5 = new Product("Jam", 65);
        Product newProduct6 = new Product("Meat", 2);
        Product newProduct7 = new Product("Cookies", 3);

        Supplier newSupplier = new Supplier("Grocery store", "Poland", "Kraków", "Reymonta", "30-072");
        Category newCategory = new Category("Food");
        Invoice newInvoice1 = new Invoice(0);
        Invoice newInvoice2 = new Invoice(0);

        newSupplier.addProduct(newProduct1);
        newSupplier.addProduct(newProduct2);
        newSupplier.addProduct(newProduct3);
        newSupplier.addProduct(newProduct4);
        newSupplier.addProduct(newProduct5);
        newSupplier.addProduct(newProduct6);
        newSupplier.addProduct(newProduct7);

        newCategory.addProduct(newProduct1);
        newCategory.addProduct(newProduct2);
        newCategory.addProduct(newProduct3);
        newCategory.addProduct(newProduct4);
        newCategory.addProduct(newProduct5);
        newCategory.addProduct(newProduct6);
        newCategory.addProduct(newProduct7);

        newInvoice1.addProduct(newProduct1);
        newInvoice1.addProduct(newProduct2);
        newInvoice1.addProduct(newProduct3);
        newInvoice1.addProduct(newProduct4);
        newInvoice1.addProduct(newProduct5);
        newInvoice2.addProduct(newProduct4);
        newInvoice2.addProduct(newProduct5);
        newInvoice2.addProduct(newProduct6);
        newInvoice2.addProduct(newProduct7);

        session.save(newProduct1);
        session.save(newProduct2);
        session.save(newProduct3);
        session.save(newProduct4);
        session.save(newProduct5);
        session.save(newProduct6);
        session.save(newProduct7);

        session.save(newSupplier);
        session.save(newCategory);
        session.save(newInvoice1);
        session.save(newInvoice2);

        printInvoiceProducts(56);
        printProductInvoices(50);

        transaction.commit();

        try {
            System.out.println("querying all the managed entities...");
            final Metamodel metamodel = session.getSessionFactory().getMetamodel();
            for (EntityType<?> entityType : metamodel.getEntities()) {
                final String entityName = entityType.getName();
                final Query query = session.createQuery("from " + entityName);
                System.out.println("executing: " + query.getQueryString());
                for (Object o : query.list()) {
                    System.out.println("  " + o);
                }
            }
        } finally {
            session.close();
        }
    }
}