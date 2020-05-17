# Hibernate
#### Author: Uladzislau Tumilovich

## Sprawozdanie

**Zadanie II. Basics**

**a) - h)** Został uruchomiony server Derby. W konsli ij zostało wywołano polecenie _connect 'jdbc:derby://127.0.0.1/UTumilovichJPA;create=true';_ oraz _show tables;_

![show tables;](res/result2.jpg)

**i)** Został stworzony projekt Javowy o nazwie UTumilovichJPAPractice w Intellij

**j) - l)** Została stworzona klasa Product z polami _ProductName_ oraz _UnitsOnStock_. Dodatkowo zostały dołączone potrzebujęce Jar-ki dla uruchomienia projektu

````java
@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    public int productId;
    public String productName;
    public int unitsOnStock;

    public Product() {
    }

    public Product(String productName, int unitsOnStock) {
        this.productName = productName;
        this.unitsOnStock = unitsOnStock;
    }
}
````

**m)** Zostały uzupełnione potrzebne property w konfiguracji hibernate'a

````java
<?xml version='1.0' encoding='utf-8'?>
<!DOCTYPE hibernate-configuration PUBLIC
        "-//Hibernate/Hibernate Configuration DTD//EN"
        "http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">
<hibernate-configuration>
    <session-factory>
        <property name="connection.url">jdbc:derby://127.0.0.1/UTumilovichJPA</property>
        <property name="connection.driver_class">org.apache.derby.jdbc.ClientDriver</property>
        <property name="dialect">org.hibernate.dialect.DerbyTenSevenDialect</property>
        <property name="format_sql">true</property>
        <property name="show_sql">true</property>
        <property name="use_sql_comments">true</property>
        <!-- DB schema will be updated if needed -->
        <property name="hibernate.hbm2ddl.auto">update</property>
        <mapping class="Product"></mapping>
    </session-factory>
</hibernate-configuration>
````

**Zadanie III**

**a)** Został stworzony i dodany do bazy przykładowy produkt w metodzie _main_ classy **Main**

````java
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

    public static void main(final String[] args) throws Exception {
        final Session session = getSession();

        Transaction transaction = session.beginTransaction();
        session.save(new Product("Laptop", 100));
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
````

**b)** Rezultaty działania programu:

Informacja że tabela została stworzona
![table creation](result3.jpg)

Informacja, że nowy obiekt został dodany do bazy
![product added](result3_2.jpg)

Schemat bazy dannych
![scheme](scheme3.jpg)

Definicja tabeli _Product_ w bazie
![sql_product3](sql_product.jpg)

Select z tabeli _Product_
![select z product](select_product3)
