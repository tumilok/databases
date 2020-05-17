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

    public static void main(final String[] args) {
        final Session session = getSession();

        Transaction transaction = session.beginTransaction();

        // Adding category to existing products
        Category category1 = new Category("Other");
        Product product1 = session.get(Product.class, 37);
        Product product2 = session.get(Product.class, 38);
        Product product3 = session.get(Product.class, 39);

        category1.addProduct(product1);
        category1.addProduct(product2);
        category1.addProduct(product3);

        session.save(product1);
        session.save(product2);
        session.save(product3);
        session.save(category1);

        // Creating new products, suppliers and categories

        Product newProduct1 = new Product("Banana", 43);
        Product newProduct2 = new Product("Orange", 54);
        Product newProduct3 = new Product("Lemon", 23);
        Supplier newSupplier = new Supplier("FoodCompany", "Budryka", "Kraków");
        Category newCategory = new Category("Fruits");

        newSupplier.addProduct(newProduct1);
        newSupplier.addProduct(newProduct2);
        newSupplier.addProduct(newProduct3);

        newCategory.addProduct(newProduct1);
        newCategory.addProduct(newProduct2);
        newCategory.addProduct(newProduct3);

        session.save(newProduct1);
        session.save(newProduct2);
        session.save(newProduct3);
        session.save(newSupplier);
        session.save(newCategory);

        printCategoryProducts(41);
        printProductCategory(37);

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