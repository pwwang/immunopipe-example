immunopipe @ImmunopipeMinimal.config.toml --name ImmunopipeMinimalLocal --outdir ./minimal-local
immunopipe @ImmunopipeMinimalNoTCR.config.toml --name ImmunopipeMinimalNoTCRLocal --outdir minimal-notcr-local/
immunopipe @ImmunopipeMinimalSupervised.config.toml --name ImmunopipeMinimalSupervisedLocal --outdir minimal-supervised-local
immunopipe @ImmunopipeNoTCR.config.toml --name ImmunopipeNoTCRLocal --outdir output-notcr-local/
immunopipe @ImmunopipeSupervised.config.toml --name ImmunopipeSupervisedLocal --outdir ./output-supervised-local
immunopipe @Immunopipe.config.toml --name ImmunopipeLocal --outdir ./output-local
immunopipe @ImmunopipeNoTCRWithSelection.config.toml --name ImmunopipeNoTCRWithSelectionLocal --outdir ./output-notcr-withselection-local
