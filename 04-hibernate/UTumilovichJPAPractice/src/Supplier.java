import javax.persistence.*;
import java.util.Set;
import java.util.HashSet;

@Entity
public class Supplier {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int supplierId;
    private String companyName;
    private String street;
    private String city;

    @OneToMany
    private final Set<Product> products = new HashSet<>();

    public Supplier() {
    }

    public Supplier(String companyName, String street, String city) {
        this.companyName = companyName;
        this.street = street;
        this.city = city;
    }

    public Supplier(String companyName, String street, String city, Product product) {
        this.companyName = companyName;
        this.street = street;
        this.city = city;
        this.products.add(product);
    }

    public void addProduct(Product product) {
        this.products.add(product);
    }
}
