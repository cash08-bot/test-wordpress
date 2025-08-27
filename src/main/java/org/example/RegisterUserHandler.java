package org.example;
//import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
//import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
//import com.amazonaws.services.dynamodbv2.document.DynamoDB;
//import com.amazonaws.services.dynamodbv2.document.Table;
//import com.amazonaws.services.dynamodbv2.document.Item;
//import com.amazonaws.services.lambda.runtime.Context;
//import com.amazonaws.services.lambda.runtime.RequestHandler;
//import com.amazonaws.services.s3.AmazonS3;
//import com.amazonaws.services.s3.AmazonS3ClientBuilder;
//import com.amazonaws.services.s3.model.PutObjectRequest;
//
//import java.nio.ByteBuffer;
//import java.util.Base64;
//import java.util.UUID;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import java.util.*;

public class RegisterUserHandler implements RequestHandler<Map<String, Object>, String> {

//    private final AmazonDynamoDB client = AmazonDynamoDBClientBuilder.defaultClient();
//    private final DynamoDB dynamoDB = new DynamoDB(client);
//    private final AmazonS3 s3Client = AmazonS3ClientBuilder.defaultClient();
//    private final String bucketName = System.getenv("BUCKET_NAME");

    @Override
    public String handleRequest(Map<String, Object> input, Context context) {
//        try {
//            // Extract input data
//            String name = (String) input.get("name");
//            String email = (String) input.get("email");
//            String password = (String) input.get("password");
//            String imageData = (String) input.get("imageData");
//
//            // Generate userId and imageKey
//            String userId = UUID.randomUUID().toString();
//            String imageKey = "images/" + userId + ".jpg";
//
//            // Decode and upload image to S3
//            byte[] imageBytes = Base64.getDecoder().decode(imageData);
//            s3Client.putObject(new PutObjectRequest(bucketName, imageKey, ByteBuffer.wrap(imageBytes).array(), null));
//
//            // Save user details and image metadata to DynamoDB
//            Table table = dynamoDB.getTable("Users");
//            Item item = new Item()
//                    .withPrimaryKey("userId", userId)
//                    .withString("name", name)
//                    .withString("email", email)
//                    .withString("password", password)
//                    .withString("imageKey", imageKey)
//                    .withLong("imageSize", (long) imageBytes.length);
//
//            table.putItem(item);
//
//            return "User registered successfully!";
//        } catch (Exception e) {
//            context.getLogger().log("Error: " + e.getMessage());
//            return "Error registering user.";
//        }
        return "Hello";
    }
}
