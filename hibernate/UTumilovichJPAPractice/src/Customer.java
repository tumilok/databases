import javax.persistence.Entity;

@Entity
public class Customer extends Company {
    private double discount;

    public Customer() {
    }

    public Customer(String companyName, String country, String city, String street,
                    String zipCode, double discount) {
        super(companyName, country, city, street, zipCode);
        this.discount = discount;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }
}
