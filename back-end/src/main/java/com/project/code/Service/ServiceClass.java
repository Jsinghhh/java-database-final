package com.project.code.Service;

import org.springframework.stereotype.Service;

import com.project.code.Model.Inventory;
import com.project.code.Model.Product;
import com.project.code.Repo.InventoryRepository;
import com.project.code.Repo.ProductRepository;

@Service
public class ServiceClass {

    private final InventoryRepository inventoryRepository;
    private final ProductRepository productRepository;

    public ServiceClass(InventoryRepository inventoryRepository, ProductRepository productRepository) {
        this.inventoryRepository = inventoryRepository;
        this.productRepository = productRepository;
    }

    public boolean validateInventory(Inventory inventory) {
        Inventory existing = inventoryRepository.findByProductIdandStoreId(
                inventory.getProduct().getId(), inventory.getStore().getId());
        return existing == null;
    }

    public boolean validateProduct(Product product) {
        Product existing = productRepository.findByName(product.getName());
        return existing == null;
    }

    public boolean ValidateProductId(long id) {
        Product product = productRepository.findById(id);
        return product != null;
    }

    public Inventory getInventoryId(Inventory inventory) {
        return inventoryRepository.findByProductIdandStoreId(
                inventory.getProduct().getId(), inventory.getStore().getId());
    }
}
