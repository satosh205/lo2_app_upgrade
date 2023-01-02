import '../model/ExampleItem.dart';

class ExampleItemPager {
  int pageIndex = 0;
  final int pageSize;

  ExampleItemPager({
    this.pageSize = 20,
  });

  List<ExampleItem> nextBatch() {
    List<ExampleItem> batch = [];
    batch.add(ExampleItem(title:"apple"));
    batch.add(ExampleItem(title:"singh"));
    batch.add(ExampleItem(title:"one"));
    batch.add(ExampleItem(title:"three"));

    /*for (int i = 0; i < pageSize; i++) {
      batch.add(ExampleItem(title: 'Item ${pageIndex * pageSize + i}'));
    }

    pageIndex += 1;
*/
    return batch;
  }
}