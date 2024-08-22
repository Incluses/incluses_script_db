import java.util.HashMap;
import java.util.Map;

public class Postagens {
    int id;
    int arquivoId;
    int perfilId;
    String titulo;
    String legenda;

    public Map<String, Object> generateObject(int id, int arquivoId, int perfilId, String titulo, String legenda) {
        if (perfilId > 0 && titulo != null) {
             Map<String, Object> dicionario = new HashMap<>();
            dicionario.put("id", id);
            dicionario.put("arquivoId", arquivoId);
            dicionario.put("perfilId", perfilId);
            dicionario.put("titulo", titulo);
            dicionario.put("legenda", legenda);
            return dicionario;
        }
        return null;
    }

}
