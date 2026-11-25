"""A shopping list kept in a file: add, list, remove."""
import os
import sys

LIMIT = 50


def path():
    return os.environ.get("SHOPPING_FILE", "shopping.txt")


def load():
    try:
        with open(path(), encoding="utf-8") as f:
            return [line.strip() for line in f if line.strip()]
    except FileNotFoundError:
        return []


def save(items):
    with open(path(), "w", encoding="utf-8") as f:
        f.write("".join(item + "\n" for item in items))


def run(args):
    items = load()
    if len(args) == 2 and args[0] == "add":
        same = next((item for item in items if item.lower() == args[1].lower()), None)
        if same:
            return f"already in the list: {same}"
        if len(items) >= LIMIT:
            return f"list full: {LIMIT} items"
        save(items + [args[1]])
        return f"added: {args[1]}"
    if args == ["list"]:
        return "\n".join(f"{i}. {item}" for i, item in enumerate(items, 1)) or "the list is empty"
    if len(args) == 2 and args[0] == "remove":
        if args[1] not in items:
            return f"not in the list: {args[1]}"
        save([item for item in items if item != args[1]])
        return f"removed: {args[1]}"
    return "usage: shopping.py add <item> | list | remove <item>"


if __name__ == "__main__":
    print(run(sys.argv[1:]))
