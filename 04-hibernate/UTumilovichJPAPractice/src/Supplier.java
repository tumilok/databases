import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Supplier {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    public int SupplierId;
    public String CompanyName;
    public String Street;
    public String City;

    public Supplier(String companyName, String street, String city) {
        this.CompanyName = companyName;
        this.Street = street;
        this.City = city;
    }

    public Supplier() {
    }
}
