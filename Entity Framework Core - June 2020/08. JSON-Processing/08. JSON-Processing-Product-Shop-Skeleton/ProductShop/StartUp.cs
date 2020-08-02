using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Newtonsoft.Json;
using ProductShop.Data;
using ProductShop.Models;

namespace ProductShop
{
    public class StartUp
    {
        public static void Main()
        {
            ProductShopContext db = new ProductShopContext();

            //string inputJson = File.ReadAllText("../../../Datasets/categories-products.json");

            //string result = ImportCategoryProducts(db, inputJson);
            //Console.WriteLine(result);

            string json = GetCategoriesByProductsCount(db);

            if (!Directory.Exists("../../../Datasets/Results"))
            {
                Directory.CreateDirectory("../../../Datasets/Results");
            }

            File.WriteAllText("../../../Datasets/Results" + "/categories-by-products.json", json);
        }

        private static void ResetDatabase(ProductShopContext db)
        {
            db.Database.EnsureDeleted();
            Console.WriteLine("Database was successfully deleted!");
            db.Database.EnsureCreated();
            Console.WriteLine("Database was successfully created!");
        }

        //Problem 01
        public static string ImportUsers(ProductShopContext context, string inputJson)
        {
            User[] users = JsonConvert.DeserializeObject<User[]>(inputJson);

            context.Users.AddRange(users);
            context.SaveChanges();

            return $"Successfully imported {users.Length}";
 }

        //Problem 02
        public static string ImportProducts(ProductShopContext context, string inputJson)
        {
            Product[] products = JsonConvert.DeserializeObject<Product[]>(inputJson);
            context.Products.AddRange(products);
            context.SaveChanges();

            return $"Successfully imported {products.Length}";
        }

        //Problem 03
        public static string ImportCategories(ProductShopContext context, string inputJson)
        {
            Category[] categories = JsonConvert
                .DeserializeObject<Category[]>(inputJson)
                .Where(c=>c.Name!=null)
                .ToArray();
            context.Categories.AddRange(categories);
            context.SaveChanges();

            return $"Successfully imported {categories.Length}";
}

        //Problem 04
        public static string ImportCategoryProducts(ProductShopContext context, string inputJson)
        {
            CategoryProduct[] categoryProducts = JsonConvert.DeserializeObject<CategoryProduct[]>(inputJson);
            context.CategoryProducts.AddRange(categoryProducts);
            context.SaveChanges();

            return $"Successfully imported {categoryProducts.Length}";
        }

        //Problem 05
        public static string GetProductsInRange(ProductShopContext context)
        {
            var products = context
                    .Products
                    .Where(p => p.Price >= 500 && p.Price <= 1000)
                    .OrderBy(p => p.Price)
                    .Select(p => new
                    {
                        name = p.Name,
                        price = p.Price,
                        seller = p.Seller.FirstName + ' ' + p.Seller.LastName
                    })
                    .ToArray();

            string json = JsonConvert.SerializeObject(products, Formatting.Indented);

            return json;
        }

        //Problem 06
        public static string GetSoldProducts(ProductShopContext context)
        {
            var users = context
                    .Users
                    .Where(u => u.ProductsSold.Any(p => p.Buyer != null))
                    .OrderBy(u => u.LastName)
                    .ThenBy(u => u.FirstName)
                    .Select(u => new
                    {
                        firstName = u.FirstName,
                        lastName = u.LastName,
                        soldProducts = u.ProductsSold
                        .Where(p => p.Buyer != null)
                        .Select(p => new
                        {
                            name = p.Name,
                            price = p.Price,
                            buyerFirstName = p.Buyer.FirstName,
                            buyerLastName = p.Buyer.LastName
                        })
                        .ToArray()
                    })
                    .ToArray();

            string json = JsonConvert.SerializeObject(users, Formatting.Indented);

            return json;
        }

        //Problem 07
        public static string GetCategoriesByProductsCount(ProductShopContext context)
        {
            var categories = context
                    .Categories
                    .OrderByDescending(c => c.CategoryProducts.Count())
                    .Select(c => new
                    {
                        category = c.Name,
                        productsCount = c.CategoryProducts.Count(),
                        averagePrice = c.CategoryProducts
                        .Average(cp => cp.Product.Price)
                        .ToString("f2"),
                        totalRevenue = c.CategoryProducts
                        .Sum(cp => cp.Product.Price)
                        .ToString("f2")
                    })
                    .ToArray();

            string json = JsonConvert.SerializeObject(categories, Formatting.Indented);

            return json;
        }

        //Problem 08
        public static string GetUsersWithProducts(ProductShopContext context)
        { 
        var users=context
                .Users
                .Where(u=>u.ProductsSold.Any(p=>p.Buyer!=null))
                .OrderByDescending(u=>u.ProductsSold.Sum())
                .Select(u=>new
                { 
                
                })
        }
    }
}