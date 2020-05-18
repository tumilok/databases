import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;

public class MainJPA {
    private static EntityManagerFactory entityManagerFactory;

    private static EntityManager getEntityManager() {
        if (entityManagerFactory == null) {
            entityManagerFactory = Persistence.createEntityManagerFactory("derby");
        }
        return entityManagerFactory.createEntityManager();
    }

    public static void main(String[] argv) {
        EntityManager entityManager = getEntityManager();
        EntityTransaction entityTransaction = entityManager.getTransaction();
        entityTransaction.begin();

        Product newProduct1 = new Product("Milk", 45);
        Product newProduct2 = new Product("Yogurt", 76);
        Product newProduct3 = new Product("Crisps", 34);
        Product newProduct4 = new Product("Bread", 56);
        Product newProduct5 = new Product("Jam", 65);
        Product newProduct6 = new Product("Meat", 2);
        Product newProduct7 = new Product("Cookies", 3);

        Supplier newSupplier = new Supplier("Grocery store", "Reymonta", "Kraków");
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

        entityManager.persist(newSupplier);
        entityManager.persist(newCategory);
        entityManager.persist(newInvoice1);
        entityManager.persist(newInvoice2);

        entityTransaction.commit();
        entityManager.close();
    }
}
