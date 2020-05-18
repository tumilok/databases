import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int invoiceNumber;
    private int quantity;

    @ManyToMany(cascade = CascadeType.PERSIST)
    private final Set<Product> products = new HashSet<>();

    public Invoice() {
    }

    public Invoice(int quantity) {
        this.quantity = quantity;
    }

    public int getInvoiceNumber() {
        return invoiceNumber;
    }

    public int getQuantity() {
        return quantity;
    }

    public Set<Product> getProducts() {
        return products;
    }

    public void addProduct(Product product) {
        products.add(product);
        product.getInvoices().add(this);
        this.quantity++;
    }
}
