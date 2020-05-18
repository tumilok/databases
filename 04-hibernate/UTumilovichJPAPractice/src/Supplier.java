import javax.persistence.*;
import java.util.Set;
import java.util.HashSet;

@Entity
@SecondaryTable(name="Address")
public class Supplier {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int supplierId;
    private String companyName;

    @Column(table="Address")
    private String country;
    @Column(table="Address")
    private String city;
    @Column(table="Address")
    private String street;
    @Column(table="Address")
    private String zipCode;

    @OneToMany
    @JoinColumn(name="Supplier_FK")
    private final Set<Product> products = new HashSet<>();

    public Supplier() {
    }

    public Supplier(String companyName, String country, String city, String street, String zipCode) {
        this.companyName = companyName;
        this.country = country;
        this.city = city;
        this.street = street;
        this.zipCode = zipCode;
    }

    public Set<Product> getProducts() {
        return products;
    }

    public void addProduct(Product product) {
        this.products.add(product);
        product.setSupplier(this);
    }
}
