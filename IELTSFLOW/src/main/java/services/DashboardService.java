package services;

import java.math.BigDecimal;

public interface DashboardService {
    BigDecimal getTotalRevenue();
    Long getTotalActiveUsers();
    Long getTotalTestSubmissions();
}
