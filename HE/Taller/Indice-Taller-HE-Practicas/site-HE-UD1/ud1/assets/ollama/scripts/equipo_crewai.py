#!/usr/bin/env python3
"""Práctica 5: tres axentes coordinados con CrewAI e Ollama local."""

import os
from pathlib import Path
from crewai import Agent, Crew, LLM, Process, Task
from crewai.tools import tool

BASE = Path(__file__).resolve().parent
DATOS = BASE / "evidencias"
INFORME = BASE / "informe-equipo.md"
MODELO = os.getenv("OLLAMA_MODEL", "qwen3.5:4b")
SERVIDOR = os.getenv("OLLAMA_HOST", "http://127.0.0.1:11434")


@tool("Ler evidencia do laboratorio")
def ler_evidencia(nome: str) -> str:
    """Lee el fichero nmap.txt o http.txt del laboratorio autorizado."""
    if nome not in ("nmap.txt", "http.txt"):
        return "ERROR: fichero no autorizado"
    ficheiro = DATOS / nome
    if not ficheiro.is_file():
        return f"ERROR: no existe {nome}"
    return ficheiro.read_text(encoding="utf-8")[:4000]


def main() -> None:
    # CrewAI resolve output_file respecto ao directorio de execución.
    os.chdir(BASE)

    # Ollama é o único fornecedor de inferencia configurado.
    llm = LLM(model=f"ollama/{MODELO}", base_url=SERVIDOR, timeout=180)

    analista = Agent(
        role="Analista de evidencias",
        goal="Extraer feitos verificables de dous ficheiros do laboratorio",
        backstory="Analista técnico que diferencia observacións de hipóteses.",
        llm=llm,
        tools=[ler_evidencia],
        allow_delegation=False,
        max_iter=5,
        verbose=True,
    )
    revisor = Agent(
        role="Revisor de rigor técnico",
        goal="Detectar afirmacións non sustentadas polas evidencias",
        backstory="Revisa informes e esixe evidencias antes de atribuír CVE.",
        llm=llm,
        allow_delegation=False,
        max_iter=4,
        verbose=True,
    )
    redactor = Agent(
        role="Redactor técnico",
        goal="Redactar un informe breve, trazable e comprensible",
        backstory="Redactor profesional de informes de auditoría autorizada.",
        llm=llm,
        allow_delegation=False,
        max_iter=4,
        verbose=True,
    )

    extraccion = Task(
        description=(
            "Usa la herramienta de lectura para consultar nmap.txt y http.txt. "
            "Enumera los hechos exactos. No inventes versiones ni CVE. "
            "Es un laboratorio ficticio; no ejecutes escaneos."
        ),
        expected_output="Relación de hechos que indique su archivo de origen.",
        agent=analista,
    )
    comprobacion = Task(
        description=(
            "Revisa críticamente los hallazgos de la tarea anterior. "
            "Separa hechos, hipótesis y validaciones necesarias. "
            "Corrige cualquier atribución de vulnerabilidad sin evidencia."
        ),
        expected_output="Lista de afirmaciones sustentadas y reservas técnicas.",
        agent=revisor,
        context=[extraccion],
    )
    redaccion = Task(
        description=(
            "Con las dos tareas previas redacta un informe Markdown con "
            "título, tabla de evidencias, límites y comprobaciones pendientes. "
            "No presentes servicios abiertos como vulnerabilidades probadas."
        ),
        expected_output="Informe Markdown breve, coherente y verificable.",
        agent=redactor,
        context=[extraccion, comprobacion],
        markdown=True,
        output_file=INFORME.name,
    )

    equipo = Crew(
        agents=[analista, revisor, redactor],
        tasks=[extraccion, comprobacion, redaccion],
        process=Process.sequential,
        verbose=True,
        memory=False,
    )
    resultado = equipo.kickoff()
    print("\n[RESULTADO DO EQUIPO]\n", resultado)
    if INFORME.is_file() and INFORME.stat().st_size > 0:
        print(f"\n[OK] Informe gardado: {INFORME}")
    else:
        raise SystemExit("[ERROR] Non se xerou informe-equipo.md")


if __name__ == "__main__":
    main()
