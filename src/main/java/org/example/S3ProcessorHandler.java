package org.example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.core.ResponseInputStream;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.*;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.List;

public class S3ProcessorHandler implements RequestHandler<Object,String> {
private final S3Client s3Client=S3Client.builder()
                                        .region(Region.US_EAST_1)
                                        .credentialsProvider(DefaultCredentialsProvider.builder().build())
                                        .build();
private static final String bucketName="saimanideeplambdabucket";
private static final String folderName="process/";
@Override
    public String handleRequest(Object input, Context context)
{
    String continuationToken = null;
    int processed = 0;
    try {
        do {
            ListObjectsV2Request.Builder requestBuilder = ListObjectsV2Request.builder()
                    .bucket(bucketName)
                    .prefix(folderName)
                    .maxKeys(1000);

            if (continuationToken != null) {
                requestBuilder.continuationToken(continuationToken);
            }

            ListObjectsV2Response response = s3Client.listObjectsV2(requestBuilder.build());
            List<S3Object> objects = response.contents();

            for (S3Object object : objects) {
                String key = object.key();
                System.out.println("Processing: " + key);
                GetObjectRequest getRequest = GetObjectRequest.builder()
                        .bucket(bucketName)
                        .key(key)
                        .build();
                try (ResponseInputStream<GetObjectResponse> s3ObjectStream = s3Client.getObject(getRequest);
                     BufferedReader reader = new BufferedReader(new InputStreamReader(s3ObjectStream, StandardCharsets.UTF_8))) {

                    String content = reader.readLine();
                    System.out.println("Content: " + content);


                    Thread.sleep(50);
                }
                DeleteObjectRequest deleteRequest = DeleteObjectRequest.builder()
                        .bucket(bucketName)
                        .key(key)
                        .build();

                s3Client.deleteObject(deleteRequest);
                processed++;
            }

            continuationToken = response.isTruncated() ? response.nextContinuationToken() : null;

        } while (continuationToken != null);

        return "Processed and deleted " + processed + " files.";
    } catch (Exception e) {
        e.printStackTrace();
        return "Error: " + e.getMessage();
    }
}

}
