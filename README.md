# Brand Function Registry

Machine-readable brand specifications for the AI era.

A Brand Function is a structured JSON file that describes how a brand behaves across eight perceptual dimensions: **Semiotic**, **Narrative**, **Ideological**, **Experiential**, **Social**, **Economic**, **Cultural**, and **Temporal**. It lives at a known URL on a brand's website (`.well-known/brand.json`) so AI systems can discover it and build accurate perceptions rather than hallucinating from scattered training data.

## Why This Exists

AI shopping agents -- ChatGPT, Gemini, Claude, DeepSeek, and others -- are becoming the default tool consumers use to compare brands. These models systematically collapse brand perception:

| Dimension | AI Weight | Baseline | Status |
|-----------|:---------:|:--------:|--------|
| Experiential | 18.8 | 12.5 | Over-weighted (150%) |
| Semiotic | 14.8 | 12.5 | Over-weighted (118%) |
| Economic | 14.3 | 12.5 | Over-weighted (114%) |
| Social | 7.8 | 12.5 | Collapsed (62%) |
| Narrative | 10.5 | 12.5 | Collapsed (84%) |
| Temporal | 8.1 | 12.5 | Collapsed (65%) |
| Cultural | 7.3 | 12.5 | Collapsed (58%) |
| Ideological | 8.2 | 12.5 | Collapsed (66%) |

This is not a quirk of one model. Cross-model cosine similarity is **.977** across 24 architectures from 7 training traditions (21,350 API calls, 10 experimental runs). The collapse is structural.

The Brand Function provides the structured information AI systems need to perceive brands accurately. It is the schema.org of brand identity.

**Research**: Zharnikov (2026v), "Spectral Metamerism in AI-Mediated Brand Perception." [Zenodo preprint](https://doi.org/10.5281/zenodo.19422427).

## Registry Contents

This registry contains Brand Functions for **26 brands** across categories:

| Category | Brands |
|----------|--------|
| Luxury | Hermes, Louis Vuitton, Rolex |
| Sportswear / Outdoor | Nike, Patagonia, North Face, Lululemon |
| Automotive | Tesla, Toyota, Mercedes-Benz, Volvo, Rivian |
| Tech / Media | Apple, Samsung, Huawei, Netflix |
| Retail / FMCG | IKEA, Zara, Uniqlo, Starbucks, Coca-Cola, Dove, Trader Joe's, Whole Foods |
| Specialty | Erewhon, Emirates |

## File Structure

```
brands/
  nike/
    brand.json      # The Brand Function specification
    README.md       # Human-readable summary
  coca-cola/
    brand.json
    README.md
  ...
schema/
  brand-function-v1.schema.json   # JSON Schema for validation
```

## Brand Function Format

Each `brand.json` contains:

```json
{
  "brand": "Brand Name",
  "version": "1.0",
  "dimensions": {
    "semiotic": {
      "score": 9.0,
      "positioning": "What the brand's visual identity communicates.",
      "key_signals": ["observable evidence 1", "observable evidence 2"]
    },
    "narrative": { ... },
    "ideological": { ... },
    "experiential": { ... },
    "social": { ... },
    "economic": { ... },
    "cultural": { ... },
    "temporal": { ... }
  }
}
```

**Required fields**: `brand`, `version`, `dimensions` (all 8), and `positioning` per dimension.

**Optional fields**: `score` (0-10 intensity), `key_signals` (evidence array), `source`, `updated`.

See the [JSON Schema](schema/brand-function-v1.schema.json) for the full specification.

## How to Use

### Deploy for your brand

1. Write your Brand Function using the format above (or copy a similar brand's file as a starting point)
2. Save it as `brand.json`
3. Host it at `https://yourdomain.com/.well-known/brand.json`
4. AI crawlers that index your `.well-known` directory will discover it

### Run an AI Brand Audit

Measure how AI currently perceives your brand before and after deploying a Brand Function:

```bash
git clone https://github.com/spectralbranding/sbt-papers.git
cd sbt-papers/r15-ai-search-metamerism/experiment
# Edit brand pairs, set API key, run
python ai_search_metamerism.py --live --runs 3
```

Full audit methodology: [The $0.80 AI Brand Audit](https://spectralbranding.substack.com/p/the-080-ai-brand-audit).

### Validate a Brand Function

```bash
pip install jsonschema
python -c "
import json, jsonschema
schema = json.load(open('schema/brand-function-v1.schema.json'))
bf = json.load(open('brands/nike/brand.json'))
jsonschema.validate(bf, schema)
print('Valid.')
"
```

## Contributing

Brand Functions are community-maintained. To add or update a brand:

1. Fork this repository
2. Create `brands/brand-name/brand.json` following the schema
3. Add `brands/brand-name/README.md` with a brief human-readable summary
4. Open a pull request

**Guidelines**:
- One brand per directory
- Directory names: `lowercase-hyphen`
- All eight dimensions required; use your best judgment for scores
- `positioning` text should describe behavior, not appearance
- `key_signals` should be verifiable, observable evidence
- If you work for the brand: indicate this in your PR description

## Claim Your Brand

If you represent a brand in this registry and the specification is inaccurate, open an issue or PR. We will prioritize corrections from brand owners.

If your brand is not in the registry, add it yourself or [request it](https://github.com/spectralbranding/brand-functions/issues/new).

## Related

- [Spectral Brand Theory](https://spectralbranding.com) -- the research program behind the 8-dimension framework
- [SBT Framework](https://github.com/spectralbranding/sbt-framework) -- open-source measurement toolkit
- [AI Brand Perception series](https://spectralbranding.substack.com/p/the-080-ai-brand-audit) -- practitioner articles on Substack
- [R15 paper](https://doi.org/10.5281/zenodo.19422427) -- the empirical study (21,350 API calls, 24 models)
- [.well-known/brand.json specification](https://spectralbranding.com/spec) -- the deployment standard

## License

Brand Function data: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
JSON Schema: MIT.
