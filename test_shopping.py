import os
import tempfile
import unittest

import shopping


class ShoppingTest(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.TemporaryDirectory()
        os.environ["SHOPPING_FILE"] = os.path.join(self.dir.name, "list.txt")

    def tearDown(self):
        self.dir.cleanup()

    def test_add_then_list(self):
        self.assertEqual(shopping.run(["add", "bread"]), "added: bread")
        self.assertEqual(shopping.run(["add", "milk"]), "added: milk")
        self.assertEqual(shopping.run(["list"]), "1. bread\n2. milk")

    def test_add_twice(self):
        shopping.run(["add", "bread"])
        self.assertEqual(shopping.run(["add", "bread"]), "already in the list: bread")
        self.assertEqual(shopping.run(["add", "Bread"]), "already in the list: bread")
        self.assertEqual(shopping.run(["list"]), "1. bread")

    def test_empty(self):
        self.assertEqual(shopping.run(["list"]), "the list is empty")

    def test_full(self):
        for i in range(50):
            shopping.run(["add", f"item{i}"])
        self.assertEqual(shopping.run(["add", "salt"]), "list full: 50 items")
        self.assertEqual(len(shopping.load()), 50)

    def test_remove(self):
        shopping.run(["add", "bread"])
        shopping.run(["add", "milk"])
        self.assertEqual(shopping.run(["remove", "bread"]), "removed: bread")
        self.assertEqual(shopping.run(["list"]), "1. milk")
        self.assertEqual(shopping.run(["remove", "eggs"]), "not in the list: eggs")


if __name__ == "__main__":
    unittest.main()
