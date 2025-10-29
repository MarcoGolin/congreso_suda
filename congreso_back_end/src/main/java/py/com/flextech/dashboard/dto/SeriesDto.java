package py.com.flextech.dashboard.dto;

import java.util.List;
import java.util.Map;

public class SeriesDto {

    private List<String> labels;
    private List<Map<String, Object>> series;

    public SeriesDto(List<String> labels, List<Map<String, Object>> series) {
        this.labels = labels;
        this.series = series;
    }

    public List<String> getLabels() {
        return labels;
    }

    public void setLabels(List<String> labels) {
        this.labels = labels;
    }

    public List<Map<String, Object>> getSeries() {
        return series;
    }

    public void setSeries(List<Map<String, Object>> series) {
        this.series = series;
    }
}
