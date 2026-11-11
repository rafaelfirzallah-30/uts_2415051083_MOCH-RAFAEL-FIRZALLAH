# Repositories Layer
Folder ini bertindak sebagai jembatan antara State/Provider dan Data Source/Service:
- `drink_repository.dart`: Mengelola data CRUD log minum dari service.
- `tip_repository.dart`: Mengelola data tips hidrasi dari API service.
Prinsip: Screen/UI tidak memanggil Service langsung, melainkan melalui Provider yang menggunakan Repository.
