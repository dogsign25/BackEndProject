package userData;

/**
 * 회원 통계 정보를 담는 DTO 클래스
 * JSP에서 ${stats.total} 등으로 접근 가능
 */
public class MemberStats {
    private int total;       // 전체 회원 수
    private int active;      // 활성 회원 수
    private int premium;     // 프리미엄 회원 수
    private int newMembers;  // 신규 회원 수 (이번 달)
    
    // 기본 생성자
    public MemberStats() {
    }
    
    // 전체 생성자
    public MemberStats(int total, int active, int premium, int newMembers) {
        this.total = total;
        this.active = active;
        this.premium = premium;
        this.newMembers = newMembers;
    }
    
    // Getter/Setter
    // EL에서 ${stats.total}을 쓰면 자동으로 getTotal() 호출됨
    public int getTotal() {
        return total;
    }
    
    public void setTotal(int total) {
        this.total = total;
    }
    
    public int getActive() {
        return active;
    }
    
    public void setActive(int active) {
        this.active = active;
    }
    
    public int getPremium() {
        return premium;
    }
    
    public void setPremium(int premium) {
        this.premium = premium;
    }
    
    public int getNewMembers() {
        return newMembers;
    }
    
    public void setNewMembers(int newMembers) {
        this.newMembers = newMembers;
    }
    
    @Override
    public String toString() {
        return "MemberStats{" +
                "total=" + total +
                ", active=" + active +
                ", premium=" + premium +
                ", newMembers=" + newMembers +
                '}';
    }
}