package main;

import java.util.*;

import com.mongodb.client.model.Filters;
import org.bson.Document;

import com.mongodb.MongoClient;
import com.mongodb.client.*;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Aggregates;
import static com.mongodb.client.model.Filters.*;
import static com.mongodb.client.model.Projections.*;
import static com.mongodb.client.model.Sorts.*;

public class MongoDB {
	private static MongoDatabase db;

	public MongoDB() {
		MongoClient mongoClient = new MongoClient("localhost", 27017);
		db = mongoClient.getDatabase("yelp_dataset");
	}

	// a)
	private List<String> getBusinessCities() {
		List<String> cities = db
				.getCollection("business")
				.distinct("city", String.class)
				.into(new ArrayList<>());
		Collections.sort(cities);
		return cities;
	}

	// b)
	private long getNumberOfReviews() {
		return db
				.getCollection("review")
				.countDocuments(new Document("date",
						new Document("$gte", "2011-01-01")));
	}

	// c)
	private List<Document> getClosedBusinessesInfo() {
		return db
				.getCollection("business")
				.find(eq("open", false))
				.projection(fields(include("name", "stars", "full_address"), excludeId()))
				.into(new ArrayList<>());
	}

	// d)
	private List<Document> getUserInfo() {
		return db
				.getCollection("user")
				.find(or(eq("votes.funny", 0), eq("votes.useful", 0)))
				.sort(ascending("name"))
				.into(new ArrayList<>());
	}

	// e)
	private List<Document> getBusinessesTipNumber() {
		return db
				.getCollection("tip")
				.aggregate(Collections.singletonList(
						Aggregates.group("$business_id",
								Accumulators.sum("tips", 1)
						)
				))
				.into(new ArrayList<>());
	}

	// f)
	private List<Document> getHighRatedBusinesses() {
		return db
				.getCollection("review")
				.aggregate(Arrays.asList(
						Aggregates.group("$business_id",
								Accumulators.avg("avg_rate","$stars")
						), Aggregates.match(Filters.gte("avg_rate", 4.0))
				))
				.into(new ArrayList<>());
	}

	// g)
	private void deleteLowRatedBusinesses() {
		db.getCollection("business").deleteMany(eq("stars", 2.0));
	}

	public static void main(String[] args) {
		MongoDB mongo = new MongoDB();

		// a)
		/*
        List<String> cities = mongo.getBusinessCities();
        for (String city: cities) {
			System.out.println(city);
		}
		*/

        // b)
        // System.out.println(mongo.getNumberOfReviews());

		// c)
		/*
		List<Document> closedBusinessesInfo = mongo.getClosedBusinessesInfo();
		for (Document info: closedBusinessesInfo) {
			System.out.println(info);
		}
		*/

		// d)
		/*
		List<Document> userInfo = mongo.getUserInfo();
		for (Document info: userInfo) {
			System.out.println(info);
		}
		*/

		// e)
		/*
		List<Document> businessesTipNumber = mongo.getBusinessesTipNumber();
		for (Document info: businessesTipNumber) {
			System.out.println(info);
		}
		*/

		// f)
		/*
		List<Document> highRatedBusinesses = mongo.getHighRatedBusinesses();
		for (Document info: highRatedBusinesses) {
			System.out.println(info);
		}
		*/

		// g)
		// mongo.deleteLowRatedBusinesses();

	}
}