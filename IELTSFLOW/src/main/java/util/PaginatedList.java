package util;

import java.util.List;

public class PaginatedList<T> {
    private List<T> items;
    private int currentPage;
    private int totalPages;
    private long totalItems;
    private int pageSize;

    public PaginatedList(List<T> items, int currentPage, long totalItems, int pageSize) {
        this.items = items;
        this.currentPage = currentPage;
        this.totalItems = totalItems;
        this.pageSize = pageSize;
        this.totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (this.totalPages == 0) {
            this.totalPages = 1;
        }
    }

    public List<T> getItems() {
        return items;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public long getTotalItems() {
        return totalItems;
    }

    public int getPageSize() {
        return pageSize;
    }
}
