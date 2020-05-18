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

        entityManager.persist(new Supplier("Grocery store", "Poland", "Krakow", "Budryka", "30-072"));
        entityManager.persist(new Supplier("Food Supplier", "Belarus", "Minsk", "Kammennogorskaya", "220017"));

        entityTransaction.commit();
        entityManager.close();
    }
}
