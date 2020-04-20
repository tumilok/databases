package pl.edu.agh.bd.mongo;

import java.awt.List;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Iterator;

import com.mongodb.BasicDBList;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;

public class MongoLab {
	private MongoClient mongoClient;
	private DB db;
	
	public MongoLab() throws UnknownHostException {
		mongoClient = new MongoClient();
		db = mongoClient.getDB("ImieNazwiskoNrGrupy");
	}
	
	private void showCollections(){
		for(String name : db.getCollectionNames()){
			System.out.println("colname: "+name);
		}
	}
	
	// 	task 5a
	private int getHighRatedNumber() {
		DBCollection collection = db.getCollection("business");
		DBCursor cursor = collection.find();
		Iterator<DBObject> fields = cursor.iterator();
		int count = 0;
		String fiveStar = new String("5.0");
		while (fields.hasNext()) {
			if (fields.next().get("stars").toString().equals(fiveStar)) {
				count++;
			}
		}
		return count;		
	}
	

	public static void main(String[] args) throws UnknownHostException {
		MongoLab mongoLab = new MongoLab();
		mongoLab.showCollections();
		System.out.println(mongoLab.getHighRatedNumber());
	}

}
