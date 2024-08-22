import java.util.HashMap;
import java.util.Map;
import java.util.Date;  

public class Likes {
    int id;
    int postagemId
    int perfilId
    new Date data_like
    boolean like

    public Map<String, Object> generateObject(int postagemId, int id, int perfilId, Date data_like, boolean like) {
        if (perfilId > 0 && postagemId > 0) {
             Map<String, Object> dicionario = new HashMap<>();
            dicionario.put("id", id);
            dicionario.put("postagemId", postagemId);
            dicionario.put("perfilId", perfilId);
            dicionario.put("data_like", data_like);
            dicionario.put("like", like);
            return dicionario;
        }
        return null;
    }

}


