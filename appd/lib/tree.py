import os

def print_lib_tree(startpath='lib'):
    """Génère l'arborescence du dossier lib avec les vrais caractères d'arbre"""
    
    if not os.path.exists(startpath):
        print(f"Le dossier '{startpath}' n'existe pas.")
        return
    
    print(f"{startpath}/")
    
    def generate_tree(current_path, prefix=""):
        try:
            # Obtenir tous les éléments (dossiers + fichiers)
            items = []
            
            for item in os.listdir(current_path):
                item_path = os.path.join(current_path, item)
                if os.path.isdir(item_path):
                    items.append((item, True, item_path))  # (nom, est_dossier, chemin)
                else:
                    items.append((item, False, item_path))
            
            # Trier : dossiers d'abord, puis fichiers
            items.sort(key=lambda x: (not x[1], x[0].lower()))
            
            for i, (name, is_dir, path) in enumerate(items):
                is_last = i == len(items) - 1
                
                if is_last:
                    current_prefix = "└── "
                    next_prefix = prefix + "    "
                else:
                    current_prefix = "├── "
                    next_prefix = prefix + "│   "
                
                if is_dir:
                    print(f"{prefix}{current_prefix}{name}/")
                    generate_tree(path, next_prefix)
                else:
                    print(f"{prefix}{current_prefix}{name}")
                    
        except PermissionError:
            print(f"{prefix}[Permission refusée]")
    
    generate_tree(startpath)

# Utilisation
if __name__ == "__main__":
    print_lib_tree()