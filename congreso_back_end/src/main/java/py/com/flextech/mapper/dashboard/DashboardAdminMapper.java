package py.com.flextech.mapper.dashboard;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface DashboardAdminMapper {
    Long countUniqueCheckinsToday(@Param("startOfDay") String startOfDay, @Param("endOfDay") String endOfDay);
    Long countConfirmedParticipants();
    Long countMorningCheckins(@Param("startOfDay") String startOfDay, @Param("noon") String noon);
    Long countAfternoonCheckins(@Param("noon") String noon, @Param("endOfDay") String endOfDay);
    List<Map<String, Object>> countByCheckinType(@Param("startOfDay") String startOfDay, @Param("endOfDay") String endOfDay);
    List<Map<String, Object>> countHourlyCheckins(@Param("startOfDay") String startOfDay, @Param("endOfDay") String endOfDay);
    List<Map<String, Object>> countQuarterlyCheckins(@Param("startOfDay") String startOfDay, @Param("endOfDay") String endOfDay);
    List<Map<String, Object>> findTopWorkshops(@Param("startOfDay") String startOfDay, @Param("endOfDay") String endOfDay, @Param("limit") int limit);
    List<Map<String, Object>> findNoShows(@Param("startOfDay") String startOfDay, @Param("endOfDay") String endOfDay);
}
