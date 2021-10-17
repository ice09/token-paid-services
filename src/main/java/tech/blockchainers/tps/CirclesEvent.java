package tech.blockchainers.tps;

import lombok.Builder;

import java.util.List;

@Builder
public class CirclesEvent {

    private String event;
    private List<String> eventParams;

    @Override
    public String toString() {
        return "CirclesEvent{" +
                "event='" + event + '\'' +
                ", eventParams=" + eventParams +
                '}';
    }
}
