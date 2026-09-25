import {
  CakeSlice,
  Croissant,
  CupSoda,
  EggFried,
  Flame,
  Salad,
  Soup,
  Utensils,
  Wheat,
} from "lucide-react";

// `CategoryDto` không có field icon (xem packages/shared/src/types/category.ts), nên icon
// suy ra từ tên danh mục. Khớp theo thứ tự, không khớp gì thì về Utensils — thêm keyword
// mới ở đây thay vì hardcode icon trong từng trang.
const rules: [RegExp, typeof Utensils][] = [
  [/tráng miệng|dessert|ngọt|kem/i, CakeSlice],
  [/bánh|bake|nướng bánh/i, Croissant],
  [/súp|soup|canh|cháo/i, Soup],
  [/salad|rau|chay|vegan/i, Salad],
  [/uống|drink|nước|cà phê|trà/i, CupSoda],
  [/sáng|breakfast|trứng/i, EggFried],
  [/nướng|grill|bbq|cay/i, Flame],
  [/mì|bún|phở|cơm|pasta|noodle/i, Wheat],
];

export function CategoryIcon({ name, className }: { name: string; className?: string }) {
  const Icon = rules.find(([pattern]) => pattern.test(name))?.[1] ?? Utensils;
  return <Icon className={className} aria-hidden />;
}
