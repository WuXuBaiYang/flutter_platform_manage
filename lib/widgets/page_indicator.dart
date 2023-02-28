import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_platform_manage/manager/theme.dart';

// 分页信息回调
typedef OnPaginationChange = void Function(int pageIndex, int pageSize);

/*
* 分页指示器
* @author wuxubaiyang
* @Time 2022/11/11 15:09
*/
class PageIndicator extends StatelessWidget {
  // 当前页码
  final int currentPage;

  // 单页数据量
  final int currentSize;

  // 分页数量
  final int pageCount;

  // 最大展示数量
  final int maxShowPage;

  // 页码变动回调
  final OnPaginationChange? onChange;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
    this.currentSize = 20,
    this.onChange,
    this.maxShowPage = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (pageCount > 0) ...[
          _buildIndicator(),
          const SizedBox(width: 14),
        ],
        _buildPageSizeSelector(),
      ],
    );
  }

  // 构建页码指示器
  Widget _buildIndicator() {
    if (pageCount <= 0) return const SizedBox();
    final count = pageCount > maxShowPage ? maxShowPage : pageCount;
    final offset = _getOffset(count);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(
            FluentIcons.page_left,
            size: 25,
          ),
          onPressed: () => _updatePageIndex(currentPage - 1),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              count,
              (i) => _buildIndicatorItem(i + offset),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            FluentIcons.page_right,
            size: 25,
          ),
          onPressed: () => _updatePageIndex(currentPage + 1),
        ),
      ],
    );
  }

  // 构建指示器子项
  Widget _buildIndicatorItem(int index) {
    final selected = index == currentPage;
    final theme = themeManage.currentTheme;
    final textColor = theme.brightness == Brightness.dark || selected
        ? Colors.white
        : Colors.black;
    return GestureDetector(
      child: CircleAvatar(
        radius: 18,
        backgroundColor: selected ? theme.accentColor : Colors.transparent,
        child: Text(
          '$index',
          style: TextStyle(color: textColor),
        ),
      ),
      onTap: () => _updatePageIndex(index),
    );
  }

  // 构建单页数据量选择器
  Widget _buildPageSizeSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('每页'),
        const SizedBox(width: 8),
        ComboBox<int>(
          value: currentSize,
          items: List.generate(5, (i) {
            final size = (i + 1) * 20;
            return ComboBoxItem(
              value: size,
              child: Text('$size'),
            );
          }),
          onChanged: (v) {
            if (v != null) _updatePageSize(v);
          },
        ),
        const SizedBox(width: 8),
        const Text('条'),
      ],
    );
  }

  // 改变页码
  void _updatePageIndex(int index) {
    if (index <= 0 || index > pageCount || index == currentPage) return;
    onChange?.call(index, currentSize);
  }

  // 改变单页数据量
  void _updatePageSize(int size) {
    if (size < 0 || size == currentSize) return;
    onChange?.call(currentPage, size);
  }

  // 计算指示器下标偏移量
  int _getOffset(int count) {
    final h = count ~/ 2;
    if (currentPage <= h) return 1;
    if (pageCount >= currentPage + h) return currentPage - h;
    return (pageCount - count) + 1;
  }
}
