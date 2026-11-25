package com.project.code.Controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.project.code.Model.Customer;
import com.project.code.Model.Review;
import com.project.code.Repo.CustomerRepository;
import com.project.code.Repo.ReviewRepository;

@RestController
@RequestMapping("/reviews")
public class ReviewController {

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private CustomerRepository customerRepository;

    @GetMapping("/{storeId}/{productId}")
    public Map<String, Object> getReviews(@PathVariable Long storeId, @PathVariable Long productId) {
        Map<String, Object> response = new HashMap<>();

        List<Review> reviews = reviewRepository.findByStoreIdAndProductId(storeId, productId);
        List<Map<String, Object>> filteredReviews = new ArrayList<>();

        for (Review review : reviews) {
            Map<String, Object> item = new HashMap<>();
            item.put("comment", review.getComment());
            item.put("rating", review.getRating());

            Customer customer = null;
            if (review.getCustomerId() != null) {
                customer = customerRepository.findById(review.getCustomerId().longValue());
            }

            item.put("customerName", customer != null ? customer.getName() : "Unknown");
            filteredReviews.add(item);
        }

        response.put("reviews", filteredReviews);
        return response;
    }
}
