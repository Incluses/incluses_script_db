import java.util.HashMap;
import java.util.Map;

public class Comentatios {
    int id;
    int postagemId
    int perfilId
    String comentatio
    boolean like

    public Map<String, Object> generateObject(int postagemId, int id, int perfilId, String comentatio, boolean like) {
        if (perfilId > 0 && comentatio != null) {
             Map<String, Object> dicionario = new HashMap<>();
            dicionario.put("id", id);
            dicionario.put("postagemId", postagemId);
            dicionario.put("perfilId", perfilId);
            dicionario.put("comentatio", comentatio);
            dicionario.put("like", like);
            return dicionario;
        }
        return null;
    }

}


