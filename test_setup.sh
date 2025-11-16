#!/bin/bash

echo "🚀 Muavin Bey - Test Kurulumu"
echo "================================"
echo ""

# Xcode projesi kontrolü
if [ -d "*.xcodeproj" ] || [ -d "*.xcworkspace" ]; then
    echo "✅ Xcode projesi bulundu"
else
    echo "⚠️  Xcode projesi bulunamadı"
    echo ""
    echo "📝 Xcode'da yeni proje oluşturma adımları:"
    echo "1. Xcode'da File > New > Project"
    echo "2. iOS > App seçin"
    echo "3. Product Name: MuavinBey"
    echo "4. Interface: SwiftUI"
    echo "5. Language: Swift"
    echo "6. Minimum iOS: 16.0"
    echo ""
    echo "Dosyaları eklemek için:"
    echo "1. Proje klasörüne sağ tıklayın"
    echo "2. 'Add Files to MuavinBey...' seçin"
    echo "3. Tüm klasörleri seçin (Models, Storage, ViewModels, Views)"
    echo "4. MuavinApp.swift dosyasını ekleyin"
    echo ""
fi

echo ""
echo "📁 Mevcut dosyalar:"
echo ""

# Dosya kontrolü
files=(
    "Models/Trip.swift"
    "Models/Stop.swift"
    "Models/Seat.swift"
    "Storage/TripsStorage.swift"
    "ViewModels/TripViewModel.swift"
    "Views/StartView.swift"
    "Views/StopManagementView.swift"
    "Views/SeatAssignmentView.swift"
    "Views/TripSummaryView.swift"
    "MuavinApp.swift"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (bulunamadı)"
    fi
done

echo ""
echo "✨ Test için:"
echo "1. Xcode'da projeyi açın"
echo "2. Simulator seçin (iPhone 15 Pro)"
echo "3. ⌘ + R ile çalıştırın"
echo ""

