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

        Supplier newSupplier1 = new Supplier("Food Store", "Poland", "Kraków",
                "Budryka", "30-072", "12345678");
        Supplier newSupplier2 = new Supplier("Elektronics Store", "Poland", "Warsaw",
                "Centralna", "30-342", "87654321");
        Customer newCustomer1 = new Customer("Techno", "Belarus", "Minsk",
                "Kamennogorskaya", "220017", 0.15);
        Customer newCustomer2 = new Customer("FoodMania", "Belarus", "Brest",
                "Mogilowskaya", "343234", 0.03);

        entityManager.persist(newSupplier1);
        entityManager.persist(newSupplier2);
        entityManager.persist(newCustomer1);
        entityManager.persist(newCustomer2);

        entityTransaction.commit();
        entityManager.close();
    }
}
