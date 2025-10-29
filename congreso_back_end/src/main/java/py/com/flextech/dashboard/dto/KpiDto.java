package py.com.flextech.dashboard.dto;

public class KpiDto {
    private String name;
    private Object value;
    private Object delta;

    public KpiDto(String name, Object value) {
        this.name = name;
        this.value = value;
    }

    public KpiDto(String name, Object value, Object delta) {
        this.name = name;
        this.value = value;
        this.delta = delta;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Object getValue() {
        return value;
    }

    public void setValue(Object value) {
        this.value = value;
    }

    public Object getDelta() {
        return delta;
    }

    public void setDelta(Object delta) {
        this.delta = delta;
    }
}
